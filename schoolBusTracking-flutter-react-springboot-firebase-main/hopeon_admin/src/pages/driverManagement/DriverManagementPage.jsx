import React, { useState } from "react";
import { styled, alpha } from "@mui/material/styles";
import InputBase from "@mui/material/InputBase";
import SearchIcon from "@mui/icons-material/Search";
import DriversGrid from "./DriversGrid";
import SingleDriverPage from "./SingleDriverPage";
import AddDriverModal from "../../components/AddDriverModel";

const Search = styled("div")(({ theme }) => ({
  position: "relative",
  borderRadius: theme.shape.borderRadius,
  backgroundColor: alpha(theme.palette.common.white, 0.15),
  "&:hover": {
    backgroundColor: alpha(theme.palette.common.white, 0.25),
  },
  marginLeft: 0,
  width: "100%",
  [theme.breakpoints.up("sm")]: {
    marginLeft: theme.spacing(1),
    width: "auto",
  },
}));

const SearchIconWrapper = styled("div")(({ theme }) => ({
  padding: theme.spacing(0, 2),
  height: "100%",
  position: "absolute",
  pointerEvents: "none",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
}));

const StyledInputBase = styled(InputBase)(({ theme }) => ({
  color: "inherit",
  width: "100%",
  "& .MuiInputBase-input": {
    padding: theme.spacing(1, 1, 1, 0),
    // vertical padding + font size from searchIcon
    paddingLeft: `calc(1em + ${theme.spacing(4)})`,
    transition: theme.transitions.create("width"),
    [theme.breakpoints.up("sm")]: {
      width: "12ch",
      "&:focus": {
        width: "20ch",
      },
    },
  },
}));

export default function DriverManagementPage() {
  const [isDriverSelected, setIsDriverSelected] = React.useState(false);
  const [selectedDriver, setSelectedDriver] = React.useState(null);
  const [fetchAllDrivers, setFetchAllDrivers] = useState(() => () => {});
  if (isDriverSelected === true) {
    return (
      <SingleDriverPage
        driverData={selectedDriver}
        setIsDriverSelected={setIsDriverSelected}
        setSelectedDriver={setSelectedDriver}
      />
    );
  } else {
    return (
      <div style={{ margin: "1rem" }}>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            padding: "1rem",
          }}
        >
          <Search>
            <SearchIconWrapper>
              <SearchIcon />
            </SearchIconWrapper>
            <StyledInputBase
              placeholder="Search…"
              inputProps={{ "aria-label": "search" }}
            />
          </Search>
          <AddDriverModal fetchAllDrivers={fetchAllDrivers} />
        </div>
        <DriversGrid
          setIsDriverSelected={setIsDriverSelected}
          setSelectedDriver={setSelectedDriver}
          setFetchAllDrivers={setFetchAllDrivers}
        />
      </div>
    );
  }
}
