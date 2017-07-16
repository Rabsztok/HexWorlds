import * as THREE from 'three'
import playerStore from 'stores/playerStore'

export default class GridGeometry extends THREE.BufferGeometry {
  fromTerrain(tiles, terrain) {
    let tmpGeometry = new THREE.Geometry()

    let topGeometry = new THREE.CircleBufferGeometry(1, 6)
    topGeometry.attributes.uv.array[5] = 0.5
    topGeometry.attributes.uv.array[7] = 0.5
    topGeometry.rotateX(-Math.PI / 2)
    topGeometry.rotateY(Math.PI / 2)

    let zxGeometry = new THREE.PlaneBufferGeometry(1, 1)
    zxGeometry.attributes.uv.array[1] = 0.5
    zxGeometry.attributes.uv.array[3] = 0.5
    zxGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    zxGeometry.rotateY(-Math.PI * 5 / 6)

    let zyGeometry = new THREE.PlaneBufferGeometry(1, 1)
    zyGeometry.attributes.uv.array[1] = 0.5
    zyGeometry.attributes.uv.array[3] = 0.5
    zyGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    zyGeometry.rotateY(Math.PI * 5 / 6)

    let yxGeometry = new THREE.PlaneBufferGeometry(1, 1)
    yxGeometry.attributes.uv.array[1] = 0.5
    yxGeometry.attributes.uv.array[3] = 0.5
    yxGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    yxGeometry.rotateY(Math.PI / 2)

    let yzGeometry = new THREE.PlaneBufferGeometry(1, 1)
    yzGeometry.attributes.uv.array[1] = 0.5
    yzGeometry.attributes.uv.array[3] = 0.5
    yzGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    yzGeometry.rotateY(Math.PI / 6)

    let xzGeometry = new THREE.PlaneBufferGeometry(1, 1)
    xzGeometry.attributes.uv.array[1] = 0.5
    xzGeometry.attributes.uv.array[3] = 0.5
    xzGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    xzGeometry.rotateY(-Math.PI / 6)

    let xyGeometry = new THREE.PlaneBufferGeometry(1, 1)
    xyGeometry.attributes.uv.array[1] = 0.5
    xyGeometry.attributes.uv.array[3] = 0.5
    xyGeometry.translate(0, -0.5, Math.sqrt(3) / 2)
    xyGeometry.rotateY(-Math.PI / 2)

    tiles.map((tile) => {
      if (tile.terrain_type === terrain) {
        this.mergeGeometry(tmpGeometry, topGeometry, tile)
        this.mergeGeometry(tmpGeometry, xzGeometry, tile, {x: -1, y: 0, z: 1})
        this.mergeGeometry(tmpGeometry, yzGeometry, tile, {x: 0, y: -1, z: 1})
        this.mergeGeometry(tmpGeometry, yxGeometry, tile, {x: 1, y: -1, z: 0})
        this.mergeGeometry(tmpGeometry, zxGeometry, tile, {x: 0, y: 1, z: -1})
        this.mergeGeometry(tmpGeometry, zyGeometry, tile, {x: 1, y: 0, z: -1})
        this.mergeGeometry(tmpGeometry, xyGeometry, tile, {x: -1, y: 1, z: 0})
      }
    })

    this.fromGeometry(tmpGeometry)
    this.computeBoundingSphere()
    return this
  }

  mergeGeometry(tmpGeometry, bufferGeometry, tile, side) {
    let matrix = new THREE.Matrix4()

    matrix.makeTranslation(
        ( 2 * tile.x + tile.z) * Math.sqrt(3) / 2,
        tile.height || 1,
        tile.z * 3 / 2
    )

    let height = 1
    if (side)
      height = tile.height - this.getHeight(tile.x + side.x, tile.y + side.y, tile.z + side.z)

    if (height >= 1) {
      let geometry = new THREE.Geometry().fromBufferGeometry(bufferGeometry)
      geometry.scale(0.99999, height, 0.99999)
      tmpGeometry.merge(geometry, matrix)
    }
  }

  getHeight(x, y, z) {
    try {
      return playerStore.find(x, y, z).height
    } catch(_err) {
      return 0
    }
  }
}

