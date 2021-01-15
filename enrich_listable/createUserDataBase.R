library(shinymanager)
library(optparse)

option_list <- list(
  make_option(c("-a","--admin"), type="character", default =  NULL, help = "admin user name", metavar ="character" ),
  make_option(c("-p","--pass"), type="character", default =  NULL, help = "admin user password", metavar ="character" ),
  make_option(c("-d","--database"), type="character", default =  NULL, help = "database name", metavar ="character" ),
  make_option(c("-b","--dbpass"), type="character", default =  NULL, help = "database pass", metavar ="character" )
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


## para crear una tabla inicial de usuarios
credentials <- data.frame(
  user = c(opt$admin),
  password = c(opt$pass),
  # password will automatically be hashed
  admin = c(TRUE),
  start = NA,
  expire = NA,
  stringsAsFactors = FALSE
)

# library(keyring)
# key_set_with_value("R-fpsanz-key", "obiwankenobi", "1235")
# para crear la base de datos de usuarios
create_db(
  credentials_data = credentials,
  sqlite_path = opt$database,
  passphrase = opt$pass
)

saveRDS(opt$pass, opt$dbpass )
