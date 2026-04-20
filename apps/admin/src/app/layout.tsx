import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });

export const metadata: Metadata = {
  title: "StadiumIQ — Venue Operations Intelligence",
  description: "Real-time AI-powered crowd flow, incident detection, and staff dispatch for large-scale venues.",
  keywords: ["stadium", "crowd intelligence", "venue ops", "real-time analytics"],
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={inter.variable}>
      <body>{children}</body>
    </html>
  );
}
