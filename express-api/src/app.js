import express from "express"

const app = express()

app.get("/", (req, res) => {
  res.send("Hola me llamo agustin")
})

const port = process.env.PORT || 5000
app.listen(port, () => {
  console.log(`API server listening on port ${port}`)
})
