import { NextApiRequest, NextApiResponse } from "next";

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  try {
    const protocol = req.headers["x-forwarded-proto"] || "https";
    const host = req.headers["x-forwarded-host"] || req.headers["host"];
    const appBaseUrl = `${protocol}://${host}`;

    res.status(200).json({
      id: "saleor.app.extension",
      name: "Ampere Extensions",
      version: "1.0.0",
      author: "Ampere Digital",
      tokenTargetUrl: `${appBaseUrl}/api/register`, // ✅ Required in 3.20
      appUrl: `${appBaseUrl}`,
      permissions: [
        "MANAGE_APPS",
        "MANAGE_PRODUCTS",
        "MANAGE_ORDERS",
        "MANAGE_USERS"
      ],
      extensions: [
        {
          label: "My Extension",
          mount: "PRODUCT_OVERVIEW_CREATE",
          target: "POPUP",
          url: `${appBaseUrl}/your-extension-path`,
          permissions: ["MANAGE_PRODUCTS"]
        }
      ]
    });
  } catch (error) {
    console.error("Manifest generation error:", error);
    res.status(500).json({ error: "Manifest generation failed" });
  }
}
