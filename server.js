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

  try {

    const userMessage = req.body.message;

    const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;

    const response = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        model: "mistralai/mistral-7b-instruct",
        messages: [
          { role: "user", content: userMessage }
        ]
      })
    });

    const data = await response.json();

    const botReply = data.choices?.[0]?.message?.content || "No response";

    res.json({ reply: botReply });

  } catch (err) {
    console.log(err);
    res.json({ reply: "Error from AI server" });
  }

});
app.get("/weather/:city", async (req,res)=>{

  try {

    const city = req.params.city;

    const response = await fetch(
      `http://api.weatherapi.com/v1/current.json?key=${process.env.WEATHER_API_KEY}&q=${city}`
    );

    const data = await response.json();

    res.json({
      location: data.location.name,
      temp: data.current.temp_c,
      condition: data.current.condition.text,
      wind: data.current.wind_kph
    });

  } catch (err) {
    console.log(err);
    res.json({ error: "Weather fetch failed" });
  }

});
app.get("/news", async (req,res)=>{

  try {

    const response = await fetch(
      `https://newsapi.org/v2/everything?q=disaster OR flood OR earthquake OR cyclone&sortBy=publishedAt&apiKey=${process.env.NEWS_API_KEY}`
    );

    const data = await response.json();

    const articles = data.articles.slice(0,5).map(article => ({
      title: article.title,
      source: article.source.name,
      url: article.url
    }));

    res.json(articles);

  } catch (err) {
    console.log(err);
    res.json({ error: "News fetch failed" });
  }

});
const PORT = process.env.PORT || 5000;
app.listen(PORT, ()=>{
  console.log("Server running on port " + PORT);
});
