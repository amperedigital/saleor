import { NextApiRequest, NextApiResponse } from "next";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "POST") {
    return res.status(405).end(); // Method Not Allowed
  }

  const { auth_token } = req.body;
  const saleorApiUrl = req.headers["saleor-api-url"] as string;

  if (!auth_token || !saleorApiUrl) {
    return res.status(400).json({ success: false, message: "Missing token or Saleor API URL" });
  }

  try {
    const mutationCreateApp = `
      mutation appCreate($input: AppInput!) {
        appCreate(input: $input) {
          app {
            id
            name
            isActive
            appUrl
          }
          errors {
            field
            message
          }
        }
      }
    `;

    const protocol = req.headers["x-forwarded-proto"] || "https";
    const host = req.headers["x-forwarded-host"] || req.headers["host"];
    const appBaseUrl = `${protocol}://${host}`;

    const variables = {
      input: {
        name: "Ampere Extensions App",
        permissions: ["MANAGE_PRODUCTS", "MANAGE_ORDERS"],
        aboutApp: "Ampere extension app",
        appUrl: appBaseUrl,
        dataPrivacyUrl: `${appBaseUrl}/privacy`,
        homepageUrl: appBaseUrl,
        supportUrl: `${appBaseUrl}/support`,
        tokenTargetUrl: `${appBaseUrl}/api/register` // ✅ Keep it in 3.20
      }
    };

    const graphqlResponse = await fetch(saleorApiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${auth_token}`,
      },
      body: JSON.stringify({
        query: mutationCreateApp,
        variables,
      }),
    });

    const responseData = await graphqlResponse.json();
    console.log("GraphQL create app response:", responseData);

    if (responseData.errors || responseData.data?.appCreate?.errors?.length > 0) {
      return res.status(500).json({ success: false, message: "Failed to create app" });
    }

    return res.status(200).json({ success: true });
  } catch (error) {
    console.error("Error in app register handler:", error);
    return res.status(500).json({ success: false, message: "Internal server error" });
  }
}
