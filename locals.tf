locals { 
    domain_name = "redes.aleph51.com.ar" 
    //Get first 2 azs from datasource
    availability_zones = slice(data.aws_availability_zones.available.names, 0,2)
    }