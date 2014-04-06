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
renderer.setClearColorHex(0x000000, 0.5)
camera = new THREE.PerspectiveCamera( 75 , width / height , 1 , 10000 )
camera.position.x = 100
camera.position.y = 20
camera.position.z = 80
camera.up.x = 0
camera.up.y = 0
camera.up.z = 1
camera.lookAt( x:0, y:0, z:90  )
scene = new THREE.Scene()
light = new THREE.DirectionalLight(0xFF0000, 1.0, 0)
light.position.set( 100, 100, 200 )
scene.add(light)

for i in [0..50]
  cube = new THREE.Mesh(
    new THREE.CubeGeometry(30,100,20),
    new THREE.MeshLambertMaterial(color: 0xff0000)
  )
  scene.add(cube)
  cube.position.set(-30*i,0,20*i)
renderer.clear()
renderer.render(scene, camera)

animate=->
  requestAnimationFrame(animate)
  camera.position.x-=0.6
  camera.position.z+=0.4
  camera.lookAt.x-=0.6
  camera.lookAt.z+=0.4
  renderer.render(scene, camera)

animate()
