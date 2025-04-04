{
  "$GMObject":"",
  "%Name":"widget_slider",
  "eventList":[
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":64,"eventType":8,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
  ],
  "managed":true,
  "name":"widget_slider",
  "overriddenProperties":[
    {"$GMOverriddenProperty":"v1","%Name":"","name":"","objectId":{"name":"__widget","path":"objects/__widget/__widget.yy",},"propertyId":{"name":"on_mouse_left_clicked","path":"objects/__widget/__widget.yy",},"resourceType":"GMOverriddenProperty","resourceVersion":"2.0","value":"widget_slider_set_value_position",},
    {"$GMOverriddenProperty":"v1","%Name":"","name":"","objectId":{"name":"__widget","path":"objects/__widget/__widget.yy",},"propertyId":{"name":"on_mouse_left_held","path":"objects/__widget/__widget.yy",},"resourceType":"GMOverriddenProperty","resourceVersion":"2.0","value":"widget_slider_set_value_position",},
    {"$GMOverriddenProperty":"v1","%Name":"","name":"","objectId":{"name":"__gui","path":"objects/__gui/__gui.yy",},"propertyId":{"name":"scale_with_gui","path":"objects/__gui/__gui.yy",},"resourceType":"GMOverriddenProperty","resourceVersion":"2.0","value":"False",},
  ],
  "parent":{
    "name":"Widgets",
    "path":"folders/ImportedAssets/GUI and Display/Widgets.yy",
  },
  "parentObjectId":{
    "name":"__widget",
    "path":"objects/__widget/__widget.yy",
  },
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[
    {"$GMObjectProperty":"v1","%Name":"position_sprite","filters":[],"listItems":[],"multiselect":false,"name":"position_sprite","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resource":{"name":"spr_widget_slider_position","path":"sprites/spr_widget_slider_position/spr_widget_slider_position.yy",},"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"spr_widget_slider_position","varType":5,},
    {"$GMObjectProperty":"v1","%Name":"value_key","filters":[],"listItems":[],"multiselect":false,"name":"value_key","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"no_key","varType":2,},
    {"$GMObjectProperty":"v1","%Name":"value_min","filters":[],"listItems":[],"multiselect":false,"name":"value_min","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"value_max","filters":[],"listItems":[],"multiselect":false,"name":"value_max","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"100","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"value_divisions","filters":[],"listItems":[],"multiselect":false,"name":"value_divisions","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"value_increment","filters":[],"listItems":[],"multiselect":false,"name":"value_increment","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"value_round","filters":[],"listItems":[],"multiselect":false,"name":"value_round","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"False","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"value_pos","filters":[],"listItems":[],"multiselect":false,"name":"value_pos","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.5","varType":0,},
  ],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":{
    "name":"spr_widget_slider_box",
    "path":"sprites/spr_widget_slider_box/spr_widget_slider_box.yy",
  },
  "spriteMaskId":null,
  "visible":true,
}