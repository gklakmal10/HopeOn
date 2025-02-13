import {
  Avatar,
  Button,
  IconButton,
  TextField,
  FormControlLabel,
} from "@mui/material";
import React, { useState } from "react";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import EditNoteIcon from "@mui/icons-material/EditNote";
import { styled } from "@mui/material/styles";
import Switch from "@mui/material/Switch";
import OpenInNewIcon from "@mui/icons-material/OpenInNew";
import AddIcon from "@mui/icons-material/Add";
import AssignDriverListModel from "../../components/AssignDriverListModel";
import { updateVehicle } from "../../service/vehicleService";

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
export default function SingleVehiclePage({
  vehicleDate,
  setIsVehicleSelected,
  setSelectedVehicle,
}) {
  const [vehicle, setVehicle] = useState({ ...vehicleDate });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setVehicle({ ...vehicle, [name]: value });
  };

  const handleSwitchChange = (e) => {
    setVehicle({ ...vehicle, active: e.target.checked });
    saveChanges({ ...vehicle, active: e.target.checked });
  };

  const saveChanges = async(vehicleData)=>{
        await updateVehicle(vehicleData ? vehicleData :vehicle)
          .then(({ data }) => {
            setVehicle(data);
            setIsVehicleSelected(false);
            setSelectedVehicle(null);
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
            setIsVehicleSelected(false);
            setSelectedVehicle(null);
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
            <TextField
              fullWidth
              margin="normal"
              name="vehicleNo"
              label="Vehicle Number"
              variant="outlined"
              value={vehicle.vehicleNo}
              onChange={handleInputChange}
            />
            <div style={{ display: "flex" }}>
              <TextField
                sx={{ marginRight: "1rem" }}
                fullWidth
                margin="normal"
                name="type"
                label="Type"
                variant="outlined"
                value={vehicle.type}
                onChange={handleInputChange}
              />
              <TextField
                fullWidth
                margin="normal"
                name="color"
                label="Color"
                variant="outlined"
                value={vehicle.color}
                onChange={handleInputChange}
              />
            </div>
            <div style={{ display: "flex" }}>
              <TextField
                fullWidth
                sx={{ marginRight: "1rem" }}
                margin="normal"
                name="brand"
                label="Brand"
                variant="outlined"
                value={vehicle.brand}
                onChange={handleInputChange}
              />
              <TextField
                fullWidth
                margin="normal"
                name="model"
                label="Model"
                variant="outlined"
                value={vehicle.model}
                onChange={handleInputChange}
              />
            </div>
            <div style={{ display: "flex" }}>
              <TextField
                sx={{ marginRight: "1rem", flex: 1 }}
                fullWidth
                margin="normal"
                name="seatCount"
                label="Seat Count"
                type="number"
                variant="outlined"
                value={vehicle.seatCount}
                onChange={handleInputChange}
              />

              <TextField
                sx={{ flex: 3 }}
                fullWidth
                margin="normal"
                name="route"
                label="Route"
                variant="outlined"
                value={vehicle.route}
                placeholder="eg: Kesbewa - Colombo"
                onChange={handleInputChange}
              />
            </div>
            <span style={{ marginTop: "1rem", fontWeight: "bold" }}>
              Start Position
            </span>
            <div style={{ display: "flex" }}>
              <TextField
                sx={{ marginRight: "1rem", flex: 1 }}
                fullWidth
                margin="normal"
                name="startLat"
                label="Start Latitude"
                variant="outlined"
                value={vehicle.startLat}
                placeholder="6.808542"
                onChange={handleInputChange}
              />

              <TextField
                sx={{ flex: 1 }}
                fullWidth
                margin="normal"
                name="startLong"
                label="Start Longitude"
                variant="outlined"
                value={vehicle.startLong}
                placeholder="6.808542"
                onChange={handleInputChange}
              />
            </div>
            <span style={{ marginTop: "1rem", fontWeight: "bold" }}>
              End Position
            </span>
            <div style={{ display: "flex" }}>
              <TextField
                sx={{ marginRight: "1rem", flex: 1 }}
                fullWidth
                margin="normal"
                name="endLat"
                label="End Latitude"
                variant="outlined"
                value={vehicle.endLat}
                placeholder="6.808542"
                onChange={handleInputChange}
              />

              <TextField
                sx={{ flex: 1 }}
                fullWidth
                margin="normal"
                name="endLong"
                label="End Longitude"
                variant="outlined"
                value={vehicle.endLong}
                placeholder="6.808542"
                onChange={handleInputChange}
              />
            </div>
            <TextField
              fullWidth
              margin="normal"
              name="locations"
              label="Locations"
              variant="outlined"
              placeholder=" eg: Kesbewa - Piliyandala - Bokundara - Boralesgamuwa - Colombo"
              value={vehicle.locations}
              onChange={handleInputChange}
            />
          </div>
        </div>
        <div
          style={{
            display: "flex",
            flex: 1,
            width: "100%",
            flexDirection: "column",
          }}
        >
          <FormControlLabel
            control={
              <IOSSwitch
                sx={{ m: 1 }}
                checked={vehicle.active}
                onChange={handleSwitchChange}
              />
            }
            label="Active"
          />
          <div style={{ marginBottom: "1rem", marginTop: "1rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between" }}>
              <h3>Driver Details</h3>
            </div>
            {vehicle.driverId === null ? (
              <AssignDriverListModel vehicleId={vehicle.id} />
            ) : (
              <div>
                <div style={{ marginBottom: "1rem" }}>
                  Driver NIC No: {vehicle.driverNIC}{" "}
                </div>
                <div style={{ marginBottom: "1rem" }}>
                  Driver Name: {vehicle.driverName}{" "}
                </div>
                <div>Contact Number:{vehicle.driverContactNo} </div>
              </div>
            )}
          </div>
          <div style={{ marginBottom: "3rem" }}>
            <div style={{ display: "flex", justifyContent: "space-between" }}>
              <h3>Other Details</h3>
            </div>
            <div style={{ marginBottom: "1rem" }}>
              Student Count: {vehicle.seatCount - vehicle.availableSeatCount}
            </div>
            <div>Available Seat Count: {vehicle.availableSeatCount} </div>
          </div>

          <div style={{ marginBottom: "2rem" }}>
            <Button
              sx={{ width: "100%" }}
              variant="outlined"
              endIcon={<OpenInNewIcon />}
            >
              view Student list
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
