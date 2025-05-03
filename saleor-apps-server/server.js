// File: ~/SALEOR/saleor-platform/saleor-apps-server/server.js

const express = require("express");
const path = require("path");

const app = express();
const port = process.env.PORT || 8899;

// Serve static assets (logos only)
app.use("/static", express.static(path.join(__dirname, "static")));

app.get("/api/apps", (req, res) => {
  res.json([
    {
      id: "avatax",
      name: "Avatax",
      description: "Manage taxes with Avalara Avatax.",
      url: "https://avatax.saleor.app/app",
      manifestUrl: "https://avatax.saleor.app/api/manifest",
      logo: "/app-store/static/avatax.png"
    },
    {
      id: "cms",
      name: "CMS",
      description: "Connect to a headless CMS.",
      url: "https://cms.saleor.app/app",
      manifestUrl: "https://cms.saleor.app/api/manifest",
      logo: "/app-store/static/cms.png"
    },
    {
      id: "klaviyo",
      name: "Klaviyo",
      description: "Connect Saleor with Klaviyo marketing automation.",
      url: "https://klaviyo.saleor.app/app",
      manifestUrl: "https://klaviyo.saleor.app/api/manifest",
      logo: "/app-store/static/klaviyo.png"
    },
    {
      id: "products-feed",
      name: "Products Feed",
      description: "Create product feeds for marketing channels.",
      url: "https://products-feed.saleor.app/app",
      manifestUrl: "https://products-feed.saleor.app/api/manifest",
      logo: "/app-store/static/products-feed.png"
    },
    {
      id: "search",
      name: "Search",
      description: "Improve storefront search.",
      url: "https://search.saleor.app/app",
      manifestUrl: "https://search.saleor.app/api/manifest",
      logo: "/app-store/static/search.png"
    },
    {
      id: "segment",
      name: "Segment",
      description: "Integrate with Segment analytics.",
      url: "https://segment.saleor.app/app",
      manifestUrl: "https://segment.saleor.app/api/manifest",
      logo: "/app-store/static/segment.png"
    },
    {
      id: "smtp",
      name: "SMTP Email",
      description: "Send emails using SMTP server.",
      url: "https://smtp.saleor.app/app",
      manifestUrl: "https://smtp.saleor.app/api/manifest",
      logo: "/app-store/static/smtp.png"
    },
    {
      id: "stripe",
      name: "Stripe",
      description: "Accept payments with Stripe.",
      url: "https://stripe.saleor.app/app",
      manifestUrl: "https://stripe.saleor.app/api/manifest",
      logo: "/app-store/static/stripe.png"
    }
  ]);
});

app.listen(port, () => {
  console.log(`App Store server running on port ${port}`);
});
