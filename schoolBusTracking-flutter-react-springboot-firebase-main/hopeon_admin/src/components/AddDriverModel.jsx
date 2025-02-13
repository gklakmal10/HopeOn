import React, { useState } from "react";
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
import generatePassword from "../utils/generatePassword";
import { saveDriver } from "../service/driverService";

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

export default function AddDriverModal({ fetchAllDrivers }) {
  const [open, setOpen] = useState(false);
  const [driver, setDriver] = useState({
    nicNo: "",
    email: "",
    password: "",
    fullName: "",
    licenseNo: "",
    contactNo: "",
    gender: "Male",
    age: "",
    experience: "",
    location: "",
    active: true,
  });

  const handleClickOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setDriver({ ...driver, [name]: value });
  };

  const handleSwitchChange = (e) => {
    setDriver({ ...driver, active: e.target.checked });
  };

  const handleSave = async () => {
    let newDriver = { ...driver };
    newDriver.password = generatePassword();

    await saveDriver(newDriver)
      .then(() => {
        fetchAllDrivers();
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
        Add new driver
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
      >
        <DialogTitle>{"Add New Driver"}</DialogTitle>
        <DialogContent>
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              width: "100%",
            }}
          >
            <Avatar
              alt="Driver Avatar"
              src="/static/images/avatar/1.jpg"
              style={{ width: 170, height: 170 }}
            />
          </div>
          <div style={{ display: "flex" }}>
            <TextField
              fullWidth
              style={{ marginRight: "1rem" }}
              margin="normal"
              name="nicNo"
              label="NIC Number"
              variant="outlined"
              value={driver.nicNo}
              onChange={handleInputChange}
            />
            <TextField
              fullWidth
              margin="normal"
              name="licenseNo"
              label="License Number"
              variant="outlined"
              value={driver.licenseNo}
              onChange={handleInputChange}
            />
          </div>

          <TextField
            fullWidth
            margin="normal"
            name="email"
            type="email"
            label="Email"
            variant="outlined"
            value={driver.email}
            onChange={handleInputChange}
          />
          <TextField
            fullWidth
            margin="normal"
            name="fullName"
            label="Full Name"
            variant="outlined"
            value={driver.fullName}
            onChange={handleInputChange}
          />

          <div style={{ display: "flex" }}>
            <TextField
              fullWidth
              style={{ marginRight: "1rem" }}
              margin="normal"
              name="contactNo"
              label="Contact Number"
              variant="outlined"
              value={driver.contactNo}
              onChange={handleInputChange}
            />
            <FormControl sx={{ marginTop: 2, marginRight: 1, width: 300 }}>
              <InputLabel id="gender-label">Gender</InputLabel>
              <Select
                labelId="gender-label"
                label="Gender"
                name="gender"
                value={driver.gender}
                onChange={handleInputChange}
              >
                <MenuItem value="Male">Male</MenuItem>
                <MenuItem value="Female">Female</MenuItem>
              </Select>
            </FormControl>
            <TextField
              margin="normal"
              fullWidth
              name="age"
              label="Age"
              variant="outlined"
              value={driver.age}
              onChange={handleInputChange}
            />
          </div>
          <TextField
            fullWidth
            margin="normal"
            name="experience"
            label="Experience"
            variant="outlined"
            value={driver.experience}
            onChange={handleInputChange}
          />
          <TextField
            fullWidth
            margin="normal"
            name="location"
            label="Location"
            variant="outlined"
            value={driver.location}
            onChange={handleInputChange}
          />
        </DialogContent>
        <FormControlLabel
          sx={{ ml: "1rem" }}
          control={
            <IOSSwitch
              sx={{ m: 1 }}
              checked={driver.active}
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
