import type { Config } from 'tailwindcss';

export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        canvas: {
          DEFAULT: '#f0e8d2',
          muted:   '#e8dfc0',
          strong:  '#ede4cc',
          sage:    '#e4ead8',
        },
        ink: {
          DEFAULT: '#1a1210',
          brown:   '#4a3820',
          muted:   '#8a6030',
        },
        ember: {
          DEFAULT: '#c25520',
          light:   '#e86830',
        },
        amber: {
          DEFAULT: '#b07a38',
          light:   '#d4a060',
          pale:    '#c8b488',
        },
      },
      fontFamily: {
        serif: ['Spectral', 'Georgia', 'serif'],
        sans:  ['DM Sans', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
} satisfies Config;
