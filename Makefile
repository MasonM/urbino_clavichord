.PHONY: all
all: render/monochord.stl render/clavichord.stl render/clavichord.glb render/clavichord_action_diagram.glb

render/monochord.stl: monochord.scad
	openscad --enable import-function -o render/monochord.stl monochord.scad
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
render/monochord_lasercut_flat.svg: monochord_lasercut.scad
	python lasercut/convert-2d.py -k -l ../lasercut/lasercut.scad monochord_lasercut.scad render/monochord_lasercut_flat.svg

