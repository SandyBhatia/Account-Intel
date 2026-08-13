import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Account Intel — Transportation & Logistics",
  description: "Briefing tool and next-best-action engine. Verified sources only.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
