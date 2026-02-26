require('dotenv').config();

const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.get("/", (req,res)=>{
  res.send("Backend running ✅");
});

const axios = require('axios');

app.post("/chat", async (req,res)=>{
  try {

    const userMessage = req.body.message;

    const openrouterKey = process.env.OPENROUTER_API_KEY;

    const response = await axios.post(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        model: "mistralai/mistral-7b-instruct",
        messages: [
          { role: "user", content: userMessage }
        ]
      },
      {
        headers: {
          "Authorization": `Bearer ${openrouterKey}`,
          "Content-Type": "application/json"
        }
      }
    );

    const reply = response.data.choices[0].message.content;

    res.json({ reply });

  } catch(err){
    console.error(err.response?.data || err.message);
    res.status(500).json({ reply: "Chatbot error ❌" });
  }
});
app.get("/weather/:city", async (req,res)=>{
  try {

    const city = req.params.city;
    const weatherKey = process.env.WEATHER_API_KEY;

    const response = await axios.get(
      `http://api.weatherapi.com/v1/current.json?key=${weatherKey}&q=${city}`
    );

    res.json(response.data);

  } catch(err){
    res.status(500).json({ error: "Weather fetch failed" });
  }
});
app.get("/news", async (req,res)=>{
  try {

    const newsKey = process.env.NEWS_API_KEY;

    const response = await axios.get(
      `https://newsapi.org/v2/top-headlines?country=in&apiKey=${newsKey}`
    );

    res.json(response.data);

  } catch(err){
    res.status(500).json({ error: "News fetch failed" });
  }
});
const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=>{
  console.log("Server running on port " + PORT);
});