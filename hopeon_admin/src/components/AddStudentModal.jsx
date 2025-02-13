import React, { useEffect, useState } from "react";
import {
  Avatar,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControl,
  FormControlLabel,
  InputLabel,
  MenuItem,
  Select,
  TextField,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { styled } from "@mui/material/styles";
import Switch from "@mui/material/Switch";
import { findAllGradeClass } from "../service/gradeClassService";
import generatePassword from "../utils/generatePassword";
import { saveStudent } from "../service/studentService";

const IOSSwitch = styled((props) => (
  <Switch focusVisibleClassName=".Mui-focusVisible" disableRipple {...props} />
))(({ theme }) => ({
  width: 42,
  height: 26,
  padding: 0,
  "& .MuiSwitch-switchBase": {
    padding: 0,
    margin: 2,
    transitionDuration: "300ms",
    "&.Mui-checked": {
      transform: "translateX(16px)",
      color: "#fff",
      "& + .MuiSwitch-track": {
        backgroundColor: "#65C466",
        opacity: 1,
        border: 0,
      },
    },
  },
  "& .MuiSwitch-thumb": {
    width: 22,
    height: 22,
  },
  "& .MuiSwitch-track": {
    borderRadius: 13,
    backgroundColor: "#E9E9EA",
    opacity: 1,
    transition: theme.transitions.create(["background-color"], {
      duration: 500,
    }),
  },
}));

export default function AddStudentModal({fetchAllStudents}) {
  const [grades, setGrades] = useState([]);
  const [selectedClasses, setSelectedClasses] = useState([]);
  const [open, setOpen] = useState(false);

  const [student, setStudent] = useState({
    regNo: "",
    email: "",
    password: "",
    fullName: "",
    grade: "",
    studentClass: "",
    parentName: "",
    contactNo: "",
    gender: "Male",
    age: 10,
    location: "",
    active: true,
  });


  const handleClickOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);


  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setStudent({ ...student, [name]: value });
  };

  const handleSwitchChange = (e) => {
    setStudent({ ...student, active: e.target.checked });
  };

  const handleGradeChange = (e) => {
    const selectedGradeId = e.target.value;
    const selectedGrade = grades.find((g) => g.id === selectedGradeId);
    setStudent({ ...student, grade: selectedGradeId, studentClass: "" });
    setSelectedClasses(selectedGrade.classes || []);
  };

  const fetchGrades = async () => {
    await findAllGradeClass().then(({ data }) => {
      const gradeClasses = data.object.map((gc) => ({
        id: gc.id,
        grade: gc.grade,
        classes: (gc.classes + "").split(",").map((c) => {
          return c.trim();
        }),
      }));
      setGrades(gradeClasses);
      setSelectedClasses(gradeClasses[0]?.classes || []);
      setStudent((prev) => ({ ...prev, grade: gradeClasses[0]?.id || "" }));
    });
  };

  useEffect(() => {
    fetchGrades();
  }, []);


  const handleSave = async () => {
    let newStudent = { ...student };
    newStudent.grade = grades.find((g) => g.id === student.grade).grade;
    newStudent.password = generatePassword();

    await saveStudent(newStudent)
      .then(({ data }) => {
        fetchAllStudents();
        handleClose();
      })
      .catch((err) => {
        console.log(err);
        handleClose();
      });
  };

  return (
    <React.Fragment>
      <Button
        startIcon={<AddIcon />}
        variant="outlined"
        onClick={handleClickOpen}
      >
        Add new student
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
      >
        <DialogTitle>{"Add New Student"}</DialogTitle>
        <DialogContent>
          <div
            style={{
              display: "flex",
              flex: 1,
              flexDirection: "column",

              alignItems: "center",
              width: "100%",
            }}
          >
            <Avatar
              alt="Remy Sharp"
              src="/static/images/avatar/1.jpg"
              style={{ width: 170, height: 170 }}
            />
          </div>
          <TextField
            fullWidth
            margin="normal"
            name="regNo"
            label="Registration Number"
            variant="outlined"
            value={student.regNo}
            onChange={handleInputChange}
          />
          <TextField
            fullWidth
            margin="normal"
            name="email"
            type="email"
            label="Email"
            variant="outlined"
            value={student.email}
            onChange={handleInputChange}
          />
          <TextField
            fullWidth
            margin="normal"
            name="fullName"
            label="Full Name"
            variant="outlined"
            value={student.fullName}
            onChange={handleInputChange}
          />
          <div style={{ display: "flex" }}>
            <FormControl sx={{ marginTop: 2, marginRight: 1, width: 300 }}>
              <InputLabel id="grade-label">Grade</InputLabel>
              <Select
                labelId="grade-label"
                label="Grade"
                name="grade"
                value={student.grade}
                onChange={handleGradeChange}
              >
                {grades.map((grade) => (
                  <MenuItem key={grade.id} value={grade.id}>
                    {grade.grade}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
            <FormControl sx={{ marginTop: 2, width: 300 }}>
              <InputLabel id="class-label">Class</InputLabel>
              <Select
                labelId="class-label"
                label="Class"
                name="studentClass"
                value={student.studentClass}
                onChange={handleInputChange}
              >
                {selectedClasses.map((cls) => (
                  <MenuItem key={cls} value={cls}>
                    {cls}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </div>
          <TextField
            margin="dense"
            fullWidth
            name="parentName"
            label="Parent Name"
            variant="outlined"
            value={student.parentName}
            onChange={handleInputChange}
          />
          <div style={{ display: "flex" }}>
            <TextField
              margin="dense"
              fullWidth
              name="contactNo"
              label="Contact Number"
              variant="outlined"
              value={student.contactNo}
              onChange={handleInputChange}
              sx={{ marginRight: 1 }}
            />
            <FormControl sx={{ marginTop: 1, marginRight: 1, width: 300 }}>
              <InputLabel id="gender-label">Gender</InputLabel>
              <Select
                labelId="gender-label"
                label="Gender"
                name="gender"
                value={student.gender}
                onChange={handleInputChange}
              >
                <MenuItem value="Male">Male</MenuItem>
                <MenuItem value="Female">Female</MenuItem>
              </Select>
            </FormControl>
            <FormControl sx={{ marginTop: 1, width: 300 }}>
              <InputLabel id="age-label">Age</InputLabel>
              <Select
                labelId="age-label"
                label="Age"
                name="age"
                value={student.age}
                onChange={handleInputChange}
              >
                {Array.from(Array(18)).map((_, index) => (
                  <MenuItem key={index} value={index + 1}>
                    {index + 1}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </div>
          <TextField
            margin="dense"
            fullWidth
            name="location"
            label="Location"
            variant="outlined"
            value={student.location}
            onChange={handleInputChange}
          />
        </DialogContent>
        <FormControlLabel
          sx={{ ml: "1rem" }}
          control={
            <IOSSwitch
              sx={{ m: 1 }}
              checked={student.active}
              onChange={handleSwitchChange}
            />
          }
          label="Active"
        />
        <DialogActions sx={{ marginRight: "1rem", marginBottom: "1rem" }}>
          <Button variant="contained" onClick={handleClose}>
            Cancel
          </Button>
          <Button variant="contained" color="success" onClick={handleSave}>
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
