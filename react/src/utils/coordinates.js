import * as THREE from 'three'

export function worldToCube(vector) {
  const x = vector.x / Math.sqrt(3) - vector.z / 3
  const z = vector.z * 2 / 3
  const y = - x - z

  if (vector instanceof THREE.Vector3)
    return new THREE.Vector3(x,y,z)
  else
    return { x: x, y: y, z: z }
}

export function cubeToWorld(vector) {
  const x = ( 2 * vector.x + vector.z) * Math.sqrt(3) / 2
  const z = vector.z * 3 / 2

  return { x: x, z: z }
}

export function distance(source, destination) {
  return Math.sqrt(
      Math.pow(source.x - destination.x, 2) + Math.pow(source.y - destination.y, 2) + Math.pow(source.z - destination.z, 2)
  )
}