# Configuración de credenciales shiny Apps

1. añadir secure_app bajo el **ui <- dashboardPage(....)**

   ```R
   ui <- secure_app(ui, enable_admin = TRUE, theme = shinythemes::shinytheme("darkly"),
                    head_auth = HTML("<style>
                    .panel-auth{
                                     background-color: #343e48 !important;
                                     }
                                     </style>"
                                     ),
                    
                    tags_bottom = tagList(tags$div(style = "text-align: center;",
                      tags$image(
                        height = 40,
                        src = "mircen.png",
                        style = "padding-right: 10px; padding-top: 10px;"
                      ),
                      tags$image(
                        height = 50,
                        src = "imib.png"#,
                      ))
                     )
   ) 
   ```

   Esto sólo es necesario hacerlo una vez.

   

2. Añadir al comienzo del server el securer_server()

   ```R
     res_auth <- secure_server(
        check_credentials = check_credentials(
            "pathToUserDataBase",
            passphrase = readRDS("pathToDataBasePass")
        )
      )
   ```

   Cada vez que se cambie el el script y se suba al repo habría que dejar el código como está arriba, y luego ejecutar los scripts de debajo en cada server para que la cosa rule bien

   

3. Utilizando el script **replacePathCredentials.sh** sustituir *pathToUserDataBase* y *pathToDataBasePass* por las rutas y ficheros que contienen las credenciales. P.e. si hemos guardado la base de datos y el fichero con la contraseña de la base de datos en la carpeta /home/fpsanz/.users/ el script se debería ejecutar así:

   ```bash
   replacePathCredentials.sh --database /home/fpsanz/.users/users.sqlite \
   --pass /home/fpsanz/.users/dbpass.Rds
   ```

4. Por otro lado hay que crear una base de datos inicial básica con el usuario administrador como mínimo y también el fichero con la contraseña de la base de datos.  Si ya está creada la base de datos, esto no será necesario ejecutarlo

   ```bash
   Rscript --vanilla createUserDataBase.R --admin foo --pass foopass \
   --database fooddbb.sqlite --dbpass foodbpass
   ```

   

