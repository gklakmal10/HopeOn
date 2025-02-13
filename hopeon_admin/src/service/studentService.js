import http from "./httpService";

const endPoint = "/student";

export async function findAllStudents() {
  return await http.get(endPoint + "/findAll");
}
export async function saveStudent(student) {
  return await http.post(endPoint, student);
}

export async function updateStudent(student) {
  return await http.put(endPoint, student);
}

export async function assignVehicle(vehicleId, studentId) {
  return await http.put(
    endPoint + "/assignVehicle?id=" + studentId + "&vehicleId=" + vehicleId
  );
}