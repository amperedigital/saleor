import requests
import time
import os
import re

NGROK_FILE = "/ngrok/api_url.txt"
MAX_WAIT = 30

def wait_for_ngrok_file():
    print(f"⏳ Waiting for {NGROK_FILE} to appear...")
    for _ in range(MAX_WAIT):
        if os.path.exists(NGROK_FILE):
            print("✅ Found ngrok file, starting import script...")
            return
        time.sleep(1)
    print(f"❌ {NGROK_FILE} not found, exiting.")
    exit(1)

wait_for_ngrok_file()

with open(NGROK_FILE) as f:
    base_url = f.read().strip()

if not re.match(r"^https?://", base_url):
    raise ValueError(f"Invalid ngrok URL: {base_url}")

API_URL = base_url + "/graphql/"
ADMIN_EMAIL = os.environ.get("ADMIN_EMAIL", "admin@yourstore.com")
ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD", "supersecure123")

print("🚀 Starting Product Importer")
print(f"👉 Using API URL: {API_URL}")
print(f"👤 Admin Email: {ADMIN_EMAIL}")

def wait_for_api():
    print("⏳ Waiting for API to be ready...")
    for _ in range(MAX_WAIT):
        try:
            response = requests.post(API_URL, json={"query": "{ __typename }"})
            if response.status_code == 200:
                print("✅ API is ready.")
                return
            else:
                print(f"❌ API not ready yet: {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"❌ API not ready yet: {e}")
        time.sleep(2)
    raise Exception("❌ API not responding after 60 seconds.")

def get_token():
    print("🔐 Requesting auth token...")
    mutation = f'''
    mutation {{
      tokenCreate(email: "{ADMIN_EMAIL}", password: "{ADMIN_PASSWORD}") {{
        token
        errors {{
          field
          message
        }}
      }}
    }}
    '''
    res = requests.post(API_URL, json={"query": mutation})
    data = res.json()
    token = data.get("data", {}).get("tokenCreate", {}).get("token")
    if not token:
        print("❌ Login failed:", data)
        raise Exception("Could not authenticate")
    print("✅ Token received.")
    return token

def create_product(token):
    print("📦 Creating test product BPC-157...")
    mutation = '''
    mutation {
      productCreate(input: {
        name: "BPC-157",
        slug: "bpc-157",
        description: "\\"BPC-157 is a synthetic peptide known for its healing properties.\\"",
        productType: "Default",
        category: "Peptides"
      }) {
        product {
          id
          name
        }
        errors {
          field
          message
        }
      }
    }
    '''
    headers = {"Authorization": f"JWT {token}"}
    res = requests.post(API_URL, json={"query": mutation}, headers=headers)
    print("🧾 Response from API:", res.json())

if __name__ == "__main__":
    wait_for_api()
    token = get_token()
    create_product(token)
    print("✅ Product import finished.")
