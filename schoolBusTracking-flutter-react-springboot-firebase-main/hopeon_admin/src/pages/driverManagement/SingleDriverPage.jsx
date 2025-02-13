import {
  Avatar,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Divider,
  FormControl,
  FormControlLabel,
  IconButton,
  InputLabel,
  MenuItem,
  Select,
  TextField,
} from "@mui/material";
import React, { useState } from "react";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import EditNoteIcon from "@mui/icons-material/EditNote";
import { styled } from "@mui/material/styles";
import Switch from "@mui/material/Switch";
import OpenInNewIcon from "@mui/icons-material/OpenInNew";
import { updateDriver } from "../../service/driverService";

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
export default function SingleDriverPage({
  driverData,
  setIsDriverSelected,
  setSelectedDriver,
}) {
  const [driver, setDriver] = useState({ ...driverData });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setDriver({ ...driver, [name]: value });
  };
  const handleSwitchChange = (e) => {
    setDriver({ ...driver, active: e.target.checked });
    saveChanges({ ...driver, active: e.target.checked });
  };

  const saveChanges = async(driverData)=>{
      await updateDriver(driverData ? driverData :driver)
        .then(({ data }) => {
          setDriver(data);
          setIsDriverSelected(false);
          setSelectedDriver(null);
        })
        .catch((err) => {
          console.log(err);
        });
  
    }

  return (
    <div style={{ margin: "2rem" }}>
      <div style={{ display: "flex", alignItems: "center" }}>
        <IconButton
          onClick={() => {
            setIsDriverSelected(false);
            setSelectedDriver(null);
          }}
        >
          <ArrowBackIcon />
        </IconButton>
      </div>
      <div style={{ display: "flex", height: "80vh" }}>
        <div
          style={{
            display: "flex",
            flex: 1.5,
            flexDirection: "column",

            alignItems: "center",
            width: "100%",
          }}
        >
          <div style={{ margin: "1rem" }}>
            <Avatar
              alt="Remy Sharp"
              src="/static/images/avatar/1.jpg"
              style={{ width: 170, height: 170 }}
            />
          </div>
          <div
            style={{
              display: "flex",
              justifyContent: "flex-end",
              width: "90%",
            }}
          >
            <Button
              variant="contained"
              startIcon={<EditNoteIcon />}
              onClick={() => saveChanges(null)}
            >
              Edit
            </Button>
          </div>
          <div style={{ width: "90%" }}>
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
              sx={{ mb: "4rem" }}
              fullWidth
              margin="normal"
              name="location"
              label="Location"
              variant="outlined"
              value={driver.location}
              onChange={handleInputChange}
            />
          </div>
        </div>
        <div
          style={{
            display: "flex",
            flex: 1,
            width: "100%",
            marginLeft: "1rem",
            flexDirection: "column",
          }}
        >
          <FormControlLabel
            control={
              <IOSSwitch
                sx={{ m: 1 }}
                checked={driver.active}
                onChange={handleSwitchChange}
              />
            }
            label="Active"
          />
          <div style={{ marginBottom: "2rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between" }}>
              <h3>Vehicle Details</h3>
            </div>
            <div style={{ marginBottom: "1rem" }}>
              Vehicle No: {driver.vehicleNo}{" "}
            </div>
            <div>Type, Brand, Model: {driver.vehicleDetails}</div>
          </div>
          <Divider style={{ marginBottom: "1rem" }} />
        </div>
      </div>
    </div>
  );
}
