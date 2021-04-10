components {
  id: "randall"
  component: "/main/game/randall/randall.script"
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
components {
  id: "context_area"
  component: "/main/game/clickable_area/context_area.script"
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
  properties {
    id: "context_key"
    value: "randall_trousers"
    type: PROPERTY_TYPE_HASH
  }
  properties {
    id: "sprite_url"
    value: "#trousers"
    type: PROPERTY_TYPE_URL
  }
  properties {
    id: "offset"
    value: "0.0, -109.0, 0.0"
    type: PROPERTY_TYPE_VECTOR3
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/assets/randall.atlas\"\n"
  "default_animation: \"idle\"\n"
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
  id: "trousers"
  type: "sprite"
  data: "tile_set: \"/assets/hit_box.atlas\"\n"
  "default_animation: \"small_hit_box\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: -109.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
