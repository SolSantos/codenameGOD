components {
  id: "item"
  component: "/main/game/item/item.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/assets/items.atlas\"\n"
  "default_animation: \"items1\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "label"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 60.0\n"
  "  z: 0.0\n"
  "  w: 0.0\n"
  "}\n"
  "scale {\n"
  "  x: 1.0\n"
  "  y: 1.0\n"
  "  z: 1.0\n"
  "  w: 0.0\n"
  "}\n"
  "color {\n"
  "  x: 0.11157376\n"
  "  y: 0.043251142\n"
  "  z: 0.42213115\n"
  "  w: 1.0\n"
  "}\n"
  "outline {\n"
  "  x: 0.10980392\n"
  "  y: 0.043137256\n"
  "  z: 0.42352942\n"
  "  w: 1.0\n"
  "}\n"
  "shadow {\n"
  "  x: 0.0\n"
  "  y: 0.0\n"
  "  z: 0.0\n"
  "  w: 0.0\n"
  "}\n"
  "leading: 1.0\n"
  "tracking: 0.0\n"
  "pivot: PIVOT_CENTER\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "line_break: false\n"
  "text: \"\"\n"
  "font: \"/assets/fonts/label.font\"\n"
  "material: \"/builtins/fonts/label.material\"\n"
  ""
  position {
    x: 0.0
    y: 43.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
