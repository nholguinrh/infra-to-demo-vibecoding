#* Health check
#* @get /health
function() {
  list(status = jsonlite::unbox("ok"))
}
