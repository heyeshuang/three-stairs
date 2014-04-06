container="canvasContainer"
width = document.getElementById(container).clientWidth
height = document.getElementById(container).clientHeight
# alert "#{width} / #{height} "
# camera = new THREE.PerspectiveCamera(
  # 75, width / height, 1, 10000)
# camera.position.z = 1000
# scene = new THREE.Scene()
# geometry = new THREE.BoxGeometry(200, 200, 200)
renderer = new THREE.WebGLRenderer(
  antialias: true
)
renderer.setSize(width, height)
document.getElementById(container).appendChild(renderer.domElement)
renderer.setClearColorHex(0xFFFFFF, 0.5)
camera = new THREE.PerspectiveCamera( 75 , width / height , 1 , 10000 )
camera.position.x = 100
camera.position.y = 20
camera.position.z = 80
camera.up.x = 0
camera.up.y = 0
camera.up.z = 1
camera.lookAt( x:0, y:0, z:0  )
scene = new THREE.Scene()
light = new THREE.DirectionalLight(0xFF0000, 1.0, 0)
light.position.set( 100, 100, 200 )
scene.add(light)
cube = new THREE.Mesh(
  new THREE.CubeGeometry(50,100,20),
  new THREE.MeshLambertMaterial(color: 0xff0000)
  )
scene.add(cube)
cube.position.set(0,0,0)
cube = new THREE.Mesh(
  new THREE.CubeGeometry(50,100,20),
  new THREE.MeshLambertMaterial(color: 0xff0000)
  )
scene.add(cube)
cube.position.set(-50,0,20)
cube = new THREE.Mesh(
  new THREE.CubeGeometry(50,100,20),
  new THREE.MeshLambertMaterial(color: 0xff0000)
  )
scene.add(cube)
cube.position.set(50,0,-20)
renderer.clear()
renderer.render(scene, camera)
