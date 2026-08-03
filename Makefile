.PHONY: all
all: render/clavichord.stl render/clavichord.glb render/clavichord_action_diagram.glb

render/clavichord.stl: clavichord.scad
	openscad --enable import-function -o render/clavichord.stl clavichord.scad
render/clavichord.glb: clavichord.scad
	npx scad-convert clavichord.scad render/clavichord.glb
	npx gltf-optimizer -i render/clavichord.glb -o . --simplify.enabled=false
	mv clavichord_optimized.glb render/clavichord.glb
render/clavichord_action_diagram.glb: clavichord_action_diagram.scad
	npx scad-convert clavichord_action_diagram.scad render/clavichord_action_diagram.glb
	npx gltf-optimizer -i render/clavichord_action_diagram.glb -o . --simplify.enabled=false
	mv clavichord_action_diagram_optimized.glb render/clavichord_action_diagram.glb
