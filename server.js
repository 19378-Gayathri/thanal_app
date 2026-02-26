require('dotenv').config();

const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req,res)=>{
  res.send("Backend running ✅");
});

app.post("/chat", async (req,res)=>{

  const userMessage = req.body.message;

  const API_KEY = process.env.OPENAI_API_KEY;

  // Example chatbot call
  const response = {
    reply: "Hello from chatbot!"
  };

  res.json(response);
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=>{
  console.log("Server running on port " + PORT);
});