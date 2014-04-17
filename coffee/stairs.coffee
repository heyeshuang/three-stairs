container="canvasContainer"
stairDef=
  w:30
  l:100
  h:20
observer=new THREE.Vector3(0,0,100)
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
startPos=new THREE.Vector3(0,0,0)
endPos=new THREE.Vector3(0,0,0)
stepV=new THREE.Vector3(0,0,0)
stepLength=0.002
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
camera.lookAt( x:0, y:0, z:50  )
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

animate=->
  requestAnimationFrame(animate)
  switch state
    when "up"
      if endPos.clone().add(observer).distanceTo(camera.position) < 1
        state="rotate"
      else
        camera.position.add(stepV)
    when "rotate"
      while stackOfPos.length < 4
        if stackOfPos.length<1
          newPos=drawFloor("-x",new THREE.Vector3(0,0,0))
        else
          newPos=drawFloor("-x",stackOfPos[-1..][0])
        stackOfPos.push(newPos)
      startPos=endPos.clone()
      endPos=stackOfPos.shift()
      stepV=endPos.clone().
        add(observer).sub(camera.position).multiplyScalar(stepLength)
      state="up"
      # console.log(startPos)
      # console.log(endPos)
      # console.log(stepV)

  renderer.render(scene, camera)
  # while stackOfPos.length < 3
    # newPos=drawFloor("-x",stackOfPos[-1..][0])
    # stackOfPos.push(newPos)
  # startPos=stackOfPos.shift()
  # endPos=stackOfPos[0]

animate()
# TODO:spotlight & camera.setlens
# TODO:shake camera
