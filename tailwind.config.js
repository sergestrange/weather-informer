/** @type {import('tailwindcss').Config} */
import daisyui from "daisyui";

export default {
  content: [
    "./app/views/**/*.{erb,haml,html,slim}",
    "./app/frontend/**/*.{js,ts,jsx,tsx,vue}"
  ],
  theme: { extend: {} },
  plugins: [daisyui],
};
