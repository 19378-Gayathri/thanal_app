const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const fetch = require("node-fetch");

// ===== DEFINE SECRETS =====
const openrouterKey = defineSecret("OPENROUTER_KEY");
const weatherKey = defineSecret("WEATHER_KEY");
const newsKey = defineSecret("NEWS_KEY");

// ================= CHATBOT =================
exports.chatbot = onRequest(
  { secrets: [openrouterKey] },
  async (req, res) => {
    try {
      const response = await fetch(
        "https://openrouter.ai/api/v1/chat/completions",
        {
          method: "POST",
          headers: {
            "Authorization": `Bearer ${openrouterKey.value()}`,
            "Content-Type": "application/json"
          },
          body: JSON.stringify(req.body)
        }
      );

      const data = await response.json();
      res.status(200).json(data);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Chatbot failed" });
    }
  }
);

// ================= WEATHER =================
exports.weather = onRequest(
  { secrets: [weatherKey] },
  async (req, res) => {
    try {
      const city = req.query.city || "Chennai";

      const response = await fetch(
        `https://api.weatherapi.com/v1/current.json?key=${weatherKey.value()}&q=${city}`
      );

      const data = await response.json();
      res.status(200).json(data);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Weather fetch failed" });
    }
  }
);

// ================= NEWS =================
exports.news = onRequest(
  { secrets: [newsKey] },
  async (req, res) => {
    try {
      const response = await fetch(
        `https://newsapi.org/v2/top-headlines?country=in&apiKey=${newsKey.value()}`
      );

      const data = await response.json();
      res.status(200).json(data);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "News fetch failed" });
    }
  }
);