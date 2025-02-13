import * as React from "react";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import useMediaQuery from "@mui/material/useMediaQuery";
import { useTheme } from "@mui/material/styles";
import { TextField, IconButton } from "@mui/material";
import EditNoteIcon from "@mui/icons-material/EditNote";
import { updateGradeClass } from "../service/gradeClassService";

export default function EditGradeModal({ gradeData , fetchAll}) {
  const [open, setOpen] = React.useState(false);
  const [formData, setFormData] = React.useState({
    id: gradeData?.id || null,
    grade: gradeData?.grade || "",
    classes: gradeData?.classes || "",
  });

  const theme = useTheme();
  const fullScreen = useMediaQuery(theme.breakpoints.down("md"));

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSave = async () => {
    await updateGradeClass(formData)
      .then(({ data }) => {
        fetchAll();
        handleClose();
      })
      .catch((err) => {
        handleClose();
      });
  };

  return (
    <React.Fragment>
      <IconButton onClick={handleClickOpen}>
        <EditNoteIcon />
      </IconButton>
      <Dialog
        fullScreen={fullScreen}
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
      >
        <DialogTitle id="responsive-dialog-title">
          {"Edit Grade and Classes"}
        </DialogTitle>
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
              name="grade"
              label="Grade"
              value={formData.grade}
              onChange={handleInputChange}
              placeholder="Grade 5"
              style={{ marginBottom: "1rem", width: "50vh" }}
            />
            <TextField
              name="classes"
              label="Classes"
              value={formData.classes}
              onChange={handleInputChange}
              placeholder="eg: A, B, C"
            />
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button onClick={handleSave}>Save</Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
