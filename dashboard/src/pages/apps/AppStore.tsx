import React, { useEffect, useState } from "react";

interface AppData {
  id: string;
  name: string;
  description: string;
  url: string;
  manifestUrl: string;
  logo: string;
}

const AppStore: React.FC = () => {
  const [apps, setApps] = useState<AppData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/app-store/api/apps")
      .then((res) => res.json())
      .then((data) => {
        setApps(data);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return <div>Loading App Store...</div>;
  }

  return (
    <div style={{ padding: "20px" }}>
      <h1>App Store</h1>
      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
        {apps.map((app) => (
          <div key={app.id} style={{ border: "1px solid #ccc", borderRadius: "8px", padding: "16px", textAlign: "center" }}>
            <img src={app.logo} alt={app.name} style={{ width: "80px", height: "80px", objectFit: "contain", marginBottom: "10px" }} />
            <h2 style={{ fontSize: "18px", margin: "10px 0" }}>{app.name}</h2>
            <p style={{ fontSize: "14px", color: "#555" }}>{app.description}</p>
            <a href={app.manifestUrl} target="_blank" rel="noreferrer" style={{ display: "inline-block", marginTop: "10px", color: "#0070f3" }}>
              Install
            </a>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AppStore;
