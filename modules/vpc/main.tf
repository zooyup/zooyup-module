# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge({
    Name = "${var.vpc_name}-vpc"
  }, var.vpc_tags)
}

# Internet Gateway (옵션)
resource "aws_internet_gateway" "this" {
  count  = var.igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true

  tags = merge({
  Name = "${var.vpc_name}-public-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
}, var.subnet_tags)

}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge({
  Name = "${var.vpc_name}-private-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
}, var.subnet_tags)

}

# DB Subnets
resource "aws_subnet" "db" {
  count             = length(var.db_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_cidr[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge({
  Name = "${var.vpc_name}-db-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
}, var.subnet_tags)

}

# etc Subnets
resource "aws_subnet" "etc" {
  count             = length(var.etc_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.etc_cidr[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]

  tags = merge({
  Name = "${var.vpc_name}-etc-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
}, var.subnet_tags)

}
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  count = var.igw ? 1 : 0

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway (optional)
resource "aws_eip" "this" {
  count  = var.nat_count

  tags = {
    Name = "${var.vpc_name}-nat-eip-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.nat_count
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(aws_subnet.public)].id

  tags = {
    Name = "${var.vpc_name}-nat-${substr(var.azs[count.index % length(var.azs)], length(var.azs[count.index % length(var.azs)]) - 1, 1)}"
  }

  depends_on = [aws_internet_gateway.this]
}

# Private Route Table
resource "aws_route_table" "private" {
  count  = var.nat ? (var.nat_count > 1 ? length(var.azs) : 1) : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-private-rt-${var.nat_count > 1 ? substr(var.azs[count.index], length(var.azs[count.index]) - 1, 1) : "shared"}"
  }
}

# NAT 라우트
resource "aws_route" "private_nat" {
  count = var.nat ? length(aws_route_table.private) : 0
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index % var.nat_count].id
}

# Private 서브넷과 RT 연결
resource "aws_route_table_association" "private" {
  count          = var.nat ? length(var.private_cidr) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.nat_count > 1 ? count.index : 0].id
}


# DB Route Table
resource "aws_route_table" "db" {
  count  = length(var.db_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-db-rt"
  }
}

resource "aws_route_table_association" "db" {
  count          = length(var.db_cidr)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[0].id
}

# etc Route Table
resource "aws_route_table" "etc" {
  count  = length(var.etc_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-etc-rt"
  }
}

resource "aws_route_table_association" "etc" {
  count          = length(var.etc_cidr)
  subnet_id      = aws_subnet.etc[count.index].id
  route_table_id = aws_route_table.etc[0].id
}
