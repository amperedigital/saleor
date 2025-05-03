import fetch from "node-fetch";

const graphqlUrl = "http://api:8000/graphql/";
const manifestUrl = "http://host.docker.internal:3000/api/manifest";
const email = "andrew@amperedigital.ca";
const password = "supersecret";

async function getAdminToken() {
  const loginMutation = `
    mutation {
      tokenCreate(email: "${email}", password: "${password}") {
        token
        errors {
          field
          message
        }
      }
    }
  `;

  const res = await fetch(graphqlUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ query: loginMutation })
  });

  const json = await res.json();
  const token = json?.data?.tokenCreate?.token;

  if (!token) {
    throw new Error("❌ Failed to retrieve token: " + JSON.stringify(json));
  }

  return token;
}

async function registerApp(token) {
  const mutation = `
    mutation {
      appInstall(input: {
        appName: "Ampere Extensions"
        manifestUrl: "${manifestUrl}"
        permissions: [MANAGE_APPS, MANAGE_PRODUCTS, MANAGE_ORDERS, MANAGE_USERS]
      }) {
        errors {
          field
          message
        }
      }
    }
  `;

  const res = await fetch(graphqlUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`
    },
    body: JSON.stringify({ query: mutation })
  });

  const json = await res.json();
  console.log("✅ App registration result:", JSON.stringify(json, null, 2));
}

// 🚀 Final trigger to actually run it
try {
  const token = await getAdminToken();
  console.log("✅ Got token successfully");
  await registerApp(token);
  console.log("✅ Finished App registration");
} catch (err) {
  console.error("❌ App registration failed:", err.message);
}
