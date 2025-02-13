import http from "./httpService";

const endPoint = "/driver";

export async function findAllDrivers() {
  return await http.get(endPoint + "/findAll");
}

export async function findAllUnAssigned() {
  return await http.get(endPoint + "/findAllUnAssigned");
}

export async function saveDriver(driver) {
  return await http.post(endPoint, driver);
}

export async function updateDriver(driver) {
  return await http.put(endPoint, driver);
}

export async function assignVehicle(vehicleId, driverId){
    return await http.put(
      endPoint + "/assignVehicle?id=" + driverId + "&vehicleId="+ vehicleId
    );
}
