container="canvasContainer"
stairDef=
  w:30
  l:100
  h:20
width = document.getElementById(container).clientWidth
height = document.getElementById(container).clientHeight
renderer = new THREE.WebGLRenderer(
  antialias: true
)
renderer.setSize(width, height)
document.getElementById(container).appendChild(renderer.domElement)
renderer.setClearColor(0x000000, 0.5)
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

drawFloor=(orientation,startPos,numOfStairs=25,isUp=true)->
  # endPos=new THREE.Vector3(0,0,0)
  for i in [0...numOfStairs]
    if orientation is "+x" or orientation is "-x"
      cube = new THREE.Mesh(
        new THREE.CubeGeometry(stairDef.w,stairDef.l,stairDef.h),
        new THREE.MeshLambertMaterial(color: 0xff0000)
      )
    else
      cube = new THREE.Mesh(
        new THREE.CubeGeometry(stairDef.l,stairDef.w,stairDef.h),
        new THREE.MeshLambertMaterial(color: 0xff0000)
      )
    cube.position.copy(startPos)
    switch orientation
      when "+x"
        cube.position.x=startPos.x+stairDef.w*i
      when "-x"
        cube.position.x=startPos.x-stairDef.w*i
      when "+y"
        cube.position.y=startPos.y+stairDef.w*i
      when "-y"
        cube.position.y=startPos.y-stairDef.w*i
    if isUp
      cube.position.z=startPos.z+stairDef.h*i
    else
      cube.position.z=startPos.z-stairDef.h*i
    scene.add(cube)
    # cube.position.set(-stairDef.w*i,0,stairDef.h*i)
  renderer.clear()
  renderer.render(scene, camera)
  cube.position

stackOfPos=[
  new THREE.Vector3(0,0,0)
]

animate=->
  requestAnimationFrame(animate)
  # camera.position.x-=0.6
  # camera.position.z+=0.4
  # camera.lookAt.x-=0.6
  # camera.lookAt.z+=0.4
  # TODO:wrap them in a new function
  while stackOfPos.length < 3
    newPos=drawFloor("-x",stackOfPos[-1..][0])
    stackOfPos.push(newPos)
  startPos=stackOfPos.shift()
  endPos=stackOfPos[0]
  renderer.render(scene, camera)

# animate()
# TODO:spotlight & camera.setlens
