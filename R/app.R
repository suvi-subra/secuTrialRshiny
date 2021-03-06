#' Main shiny UI function for secuTrialRshiny
#'
#' Controls the general appearance, header, sidebar, body, tabs with modules, etc.
#'
#' @return shiny.tag list object containing the dashboard page
#' @seealso \code{\link{app_srv}}, \code{\link{run_shiny}}
#' @import shiny
#' @import shinydashboard
#' @export
#'
app_ui <- function(){
  # get all module names
  mod <- get_modules()
  style <- get_style("scto")
  # create dashboard page
  dashboardPage(skin = style$skin,
                dashboardHeader(title = "SCTO - secuTrialR"),
                dashboardSidebar(
                  sidebarUserPanel(name = style$logo_title,
                                   image = style$logo
                  ),
                  sidebarMenu(
                    # define sidebar menu items
                    menuItem("Upload", tabName = mod$upload, icon = icon("upload")),
                    menuItem("Recruitment plot", tabName = mod$recruitplot, icon = icon("signal")),
                    menuItem("Recruitment table", tabName = mod$recruittable, icon = icon("table")),
                    menuItem("Form completeness", tabName = mod$formcomplete, icon = icon("percent")),
                    menuItem("Visit plan", tabName = mod$visitplan, icon = icon("calendar-alt")),
                    menuItem("Monitoring cases", tabName = mod$monitorcn, icon = icon("dice")),
                    menuItem("Codebook", tabName = mod$codebook, icon = icon("book")),
                    menuItem("STATA - SAS - SPSS", tabName = mod$export, icon = icon("download"))
                  )
                ),
                dashboardBody(
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = paste0("www/custom_", style$id, ".css"))
                  ),
                  tabItems(
                    # fill dashboard body contents with module UI functions
                    mod_upload_UI(mod$upload, label = mod$upload),
                    mod_recruitplot_UI(mod$recruitplot, label = mod$recruitplot),
                    mod_recruittable_UI(mod$recruittable, label = mod$recruittable),
                    mod_formcomplete_UI(mod$formcomplete, label = mod$formcomplete),
                    mod_visitplan_UI(mod$visitplan, label = mod$visitplan),
                    mod_monitorcn_UI(mod$monitorcn, label = mod$monitorcn),
                    mod_codebook_UI(mod$codebook, label = mod$codebook),
                    mod_export_UI(mod$export, label = mod$export)
                  )
                )
  )
}

#' Main Shiny server function for secuTrialRshiny
#'
#' Calls all modules required by app_ui, and passes on relevant data.
#'
#' @param input session's input object
#' @param output session's output object
#' @seealso \code{\link{app_ui}}, \code{\link{run_shiny}}
#' @import shiny
#' @export
#'
app_srv <- function(input, output) {
  # get all module names
  mod <- get_modules()
  # init the sT export reactive Val
  sT_export <- reactiveVal()
  # call all server modules
  vals_upload <- callModule(mod_upload_srv, mod$upload, sT_export)
  callModule(mod_recruitplot_srv, mod$recruitplot, sT_export, vals_upload)
  callModule(mod_recruittable_srv, mod$recruittable, sT_export, vals_upload)
  callModule(mod_formcomplete_srv, mod$formcomplete, sT_export, vals_upload)
  callModule(mod_visitplan_srv, mod$visitplan, sT_export, vals_upload)
  callModule(mod_monitorcn_srv, mod$monitorcn, sT_export, vals_upload)
  callModule(mod_codebook_srv, mod$codebook, sT_export, vals_upload)
  callModule(mod_export_srv, mod$export, sT_export, vals_upload)
}
