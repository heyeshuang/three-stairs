container="canvasContainer"
stairDef=
  w:20
  l:80
  h:20
offset=new THREE.Vector3(-50,10,150) #相机位置偏移量
# fsm=StateMachine.create(
  # initial:'up'
  # event:[
    # {name:'u2r',from:'up',to:'rotate'},
    # {name:'r2u',from:'rotate',to:'up'}
  # ]
# ) # easily I gave up
state="rotate" #up or rotate
stackOfPos=[
]
startPos=new THREE.Vector3()
endPos=new THREE.Vector3()
stepV=new THREE.Vector3() #每一步的长度
stepLength=0.0015

# width = document.getElementById(container).clientWidth
# height = document.getElementById(container).clientHeight
width = window.innerWidth
height = window.innerHeight
renderer = new THREE.WebGLRenderer(
  antialias: true
)
renderer.setSize(width, height)
document.getElementById(container).appendChild(renderer.domElement)
renderer.setClearColor(0x000000, 0.5)
camera = new THREE.PerspectiveCamera( 75 , width / height , 1 , 10000 )
camera.position.copy(offset)
camera.up.x = 0
camera.up.y = 0
camera.up.z = 1
# camera.lookAt( x:-200, y:200, z:200  )
scene = new THREE.Scene()
scene.fog=new THREE.FogExp2(0x000000)
window.addEventListener( 'resize', onWindowResize, false )
#
# 光源设置
# light = new THREE.PointLight(0xFFFFFF, 1.0, 0)
# light.position.set( 0, 0, 5000)
# scene.add(light)

drawFloor=(orientation,startPos,numOfStairs=25,isUp=true)->
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
  #光源
  spotLight= new THREE.PointLight( 0xffffff , 1.0, 400)
  spotLight.position.copy(new THREE.Vector3(0,0,500)).
    add(cube.position).lerp(startPos, 0.5)
  scene.add( spotLight )
  sphere = new THREE.SphereGeometry( 0.5, 16, 8 )
  l1 = new THREE.Mesh(sphere,new THREE.MeshBasicMaterial(color: 0x00ff00) )
  l1.position = spotLight.position
  scene.add( l1 )
  renderer.clear()
  renderer.render(scene, camera)
  cube.position

animate=->
  requestAnimationFrame(animate)
  switch state
    when "up"
      if endPos.clone().add(offset).distanceTo(camera.position) < 1
        state="rotate"
      else
        camera.position.add(stepV)
    when "rotate"
      while stackOfPos.length < 5
        stackOfPos.push(
          drawFloor("-x",stackOfPos[-1..][0]||
            new THREE.Vector3(0,0,0),25,isUp=true))
      startPos=endPos.clone()
      endPos=stackOfPos.shift()
      stepV=endPos.clone().
        add(offset).sub(camera.position).multiplyScalar(stepLength)
      camera.lookAt(endPos.clone().add(new THREE.Vector3(0,0,-400)))
      state="up"
      console.log(endPos)
      console.log((spotLight.position).distanceTo(endPos))
      console.log("end")

  renderer.render(scene, camera)

animate()

# onWindowResize=->
  # camera.aspect = window.innerWidth / window.innerHeight
  # camera.updateProjectionMatrix()

  # renderer.setSize( window.innerWidth, window.innerHeight )
  # controls.handleResize()

# TODO:spotlight & camera.setlens
# TODO:shake camera
