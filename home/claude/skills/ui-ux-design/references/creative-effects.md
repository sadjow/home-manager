# Creative Effects

## Gradient Borders

### Animated Gradient Border with @property

```css
@property --angle {
  syntax: "<angle>";
  initial-value: 0deg;
  inherits: false;
}

.gradient-border {
  border: 3px solid transparent;
  border-radius: 12px;
  background:
    linear-gradient(#131219, #131219) padding-box,
    linear-gradient(var(--angle), #070707, #687aff) border-box;
  animation: rotate 8s linear infinite;
}

@keyframes rotate {
  to { --angle: 360deg; }
}
```

### Static Gradient Border

```css
.gradient-border-static {
  border: 2px solid transparent;
  border-radius: 0.75rem;
  background:
    linear-gradient(var(--surface), var(--surface)) padding-box,
    linear-gradient(135deg, oklch(65% 0.25 280), oklch(70% 0.2 330)) border-box;
}
```

### Conic Gradient Rotating Border

```css
.rotating-border {
  border: 2px solid transparent;
  background:
    linear-gradient(black, black) padding-box,
    conic-gradient(from var(--angle, 0deg), transparent, white 10%, transparent 20%) border-box;
}
```

---

## Glassmorphism / Frosted Glass

```css
.glass {
  background: oklch(100% 0 0 / 0.15);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid oklch(100% 0 0 / 0.2);
  border-radius: 1rem;
}

/* Colored glass */
.glass-tinted {
  background: oklch(50% 0.15 262 / 0.2);
  backdrop-filter: blur(16px) saturate(180%);
  border: 1px solid oklch(80% 0.05 262 / 0.3);
}
```

### Liquid Glass (Apple-inspired, 2025)

Uses SVG filters for light refraction and distortion effects. Performance-intensive — restrict to limited surface areas.

```html
<svg style="display: none;">
  <defs>
    <filter id="liquid-glass">
      <feGaussianBlur in="SourceGraphic" stdDeviation="1" result="blur" />
      <feDisplacementMap in="blur" in2="displacement" scale="55"
        xChannelSelector="R" yChannelSelector="G" result="displaced" />
      <feColorMatrix in="displaced" type="saturate" values="50" />
    </filter>
  </defs>
</svg>

<div style="filter: url(#liquid-glass) brightness(150%);">
  <!-- content -->
</div>
```

---

## Glow Effects

### Neon Glow Button

```css
.neon-button {
  background: oklch(15% 0 0);
  color: oklch(70% 0.2 180);
  border: none;
  border-radius: 0.5rem;
  box-shadow:
    0 0 10px oklch(60% 0.2 180),
    0 0 20px oklch(60% 0.2 180),
    0 0 30px oklch(60% 0.2 180);
  transition: box-shadow 0.3s;
}
.neon-button:hover {
  box-shadow:
    0 0 15px oklch(65% 0.25 180),
    0 0 30px oklch(65% 0.25 180),
    0 0 45px oklch(65% 0.25 180);
}
```

### Gradient Glow Button

```css
.glow-button {
  background: linear-gradient(45deg, oklch(45% 0.2 350), oklch(65% 0.25 30));
  color: white;
  border: none;
  border-radius: 0.5rem;
  box-shadow: 0 0 20px oklch(45% 0.2 350 / 0.5);
}
```

### Pulse Glow

```css
.pulse-glow {
  animation: pulse 1s infinite alternate;
}
@keyframes pulse {
  from { box-shadow: 0 0 10px oklch(60% 0.2 30 / 0.4); }
  to   { box-shadow: 0 0 20px oklch(60% 0.2 30 / 0.7); }
}
```

---

## Gradient Text

```css
.gradient-text {
  background: linear-gradient(135deg, oklch(60% 0.25 280), oklch(70% 0.2 330));
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

---

## Neumorphism

```css
.neumorph {
  background: oklch(92% 0.01 250);
  border-radius: 1rem;
  box-shadow:
    8px 8px 16px oklch(85% 0.01 250),
    -8px -8px 16px oklch(98% 0.01 250);
}
.neumorph-inset {
  box-shadow:
    inset 8px 8px 16px oklch(85% 0.01 250),
    inset -8px -8px 16px oklch(98% 0.01 250);
}
```

---

## 3D Card Tilt

```css
.tilt-card {
  transform-style: preserve-3d;
  transition: transform 0.3s;
  perspective: 1000px;
}
.tilt-card:hover {
  transform: rotateY(5deg) rotateX(-5deg);
}
.tilt-card::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(
    135deg,
    oklch(100% 0 0 / 0.1) 0%,
    oklch(100% 0 0 / 0) 50%
  );
  pointer-events: none;
}
```

---

## Mesh Gradient Background

```css
.mesh-gradient {
  background:
    radial-gradient(at 20% 30%, oklch(70% 0.2 280 / 0.8) 0%, transparent 50%),
    radial-gradient(at 80% 20%, oklch(65% 0.2 330 / 0.6) 0%, transparent 50%),
    radial-gradient(at 50% 80%, oklch(60% 0.2 200 / 0.7) 0%, transparent 50%),
    oklch(15% 0.02 262);
}
```

---

## Layered Shadows (Realistic Elevation)

Stack multiple shadows for natural depth:

```css
.elevated-sm {
  box-shadow: 0.5px 1px 1px oklch(30% 0.05 var(--brand-hue) / 0.7);
}
.elevated-md {
  box-shadow:
    0 1px 1px oklch(30% 0.05 var(--brand-hue) / 0.33),
    0 2px 2px oklch(30% 0.05 var(--brand-hue) / 0.33),
    0 4px 4px oklch(30% 0.05 var(--brand-hue) / 0.33);
}
.elevated-lg {
  box-shadow:
    0 1px 1px oklch(30% 0.05 var(--brand-hue) / 0.2),
    0 2px 2px oklch(30% 0.05 var(--brand-hue) / 0.2),
    0 4px 4px oklch(30% 0.05 var(--brand-hue) / 0.2),
    0 8px 8px oklch(30% 0.05 var(--brand-hue) / 0.2),
    0 16px 16px oklch(30% 0.05 var(--brand-hue) / 0.2);
}
```

Match shadow hue to background for natural appearance. Vertical offset = 2x horizontal.
