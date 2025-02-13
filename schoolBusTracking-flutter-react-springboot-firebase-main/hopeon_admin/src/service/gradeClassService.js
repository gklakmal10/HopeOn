import http from "./httpService";

const endPoint = "/gradeClass";

export async function findAllGradeClass() {
  return await http.get(endPoint);
}
export async function saveGradeClass(gradeClass) {
  return await http.post(endPoint, gradeClass);
}
export async function updateGradeClass(gradeClass) {
  return await http.put(endPoint, gradeClass);
}
export async function deleteGradeClass(id) {
  return await http.delete(endPoint + "?id=" + id);
}