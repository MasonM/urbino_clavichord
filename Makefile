.PHONY: all
all: render/clavichord.stl render/clavichord.glb

render/clavichord.stl: clavichord.scad
	openscad --enable import-function -o render/clavichord.stl clavichord.scad
render/clavichord.glb: clavichord.scad
	npx scad-convert clavichord.scad render/clavichord.glb
	npx gltf-optimizer -i clavichord.glb -o .
	mv clavichord_optimized.glb render/clavichord.glb
