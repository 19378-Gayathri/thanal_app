const express = require("express");
const fetch = require("node-fetch");
require("dotenv").config();
const path = require("path");

const app = express();
app.use(express.json());

// Serve Flutter build
app.use(express.static(path.join(__dirname, "build/web")));


// WEATHER API
app.get("/api/weather", async (req, res) => {
  const city = req.query.city;

  try {
    const response = await fetch(
      `http://api.weatherapi.com/v1/current.json?key=${process.env.WEATHER_KEY}&q=${city}`
    );
    const data = await response.json();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: "Weather fetch failed" });
  }
});


// NEWS API
app.get("/api/news", async (req, res) => {
  try {
    const response = await fetch(
      `https://newsapi.org/v2/top-headlines?country=in&apiKey=${process.env.NEWS_KEY}`
    );
    const data = await response.json();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: "News fetch failed" });
  }
});


// CHATBOT API (OpenRouter)
app.post("/api/chatbot", async (req, res) => {
  try {
    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${process.env.OPENROUTER_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "openai/gpt-3.5-turbo",
        messages: req.body.messages
      })
    });

    const data = await response.json();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: "Chatbot failed" });
  }
});


// Default route for Flutter
app.use((req, res) => {
    res.sendFile(path.join(__dirname, "build/web/index.html"));
  });
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));