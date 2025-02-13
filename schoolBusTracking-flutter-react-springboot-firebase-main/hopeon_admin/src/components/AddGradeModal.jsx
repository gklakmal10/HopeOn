import * as React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import AddIcon from "@mui/icons-material/Add";
import { TextField } from "@mui/material";
import { saveGradeClass } from "../service/gradeClassService";

export default function AddGradeModal({ fetchAllGradeClasses }) {
  const [open, setOpen] = React.useState(false);
  const [gradeClass, setGradeClass] = React.useState({
    grade: "",
    classes: "",
  });

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setGradeClass((prev) => ({ ...prev, [name]: value }));
  };

  const submit = async () => {
    await saveGradeClass(gradeClass)
      .then(() => {
        fetchAllGradeClasses();
        handleClose();
      })
      .catch((err) => {
        console.log(err);
      });
  };

  return (
    <React.Fragment>
      <Button
        startIcon={<AddIcon />}
        variant="outlined"
        onClick={handleClickOpen}
      >
        Add new Grade
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
      >
        <DialogTitle>{"Add New Grade and Classes"}</DialogTitle>
        <DialogContent>
          <div
            style={{
              padding: "1rem",
              display: "flex",
              flexDirection: "column",
            }}
          >
            <TextField
              required
              label="Grade"
              name="grade"
              value={gradeClass.grade}
              onChange={handleInputChange}
              style={{ marginBottom: "1rem", width: "50vh" }}
            />
            <TextField
              label="Classes"
              name="classes"
              value={gradeClass.classes}
              onChange={handleInputChange}
              placeholder="e.g., A, B, C"
            />
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button onClick={submit}>Save</Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
