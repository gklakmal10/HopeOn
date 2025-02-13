import * as React from "react";
import PropTypes from "prop-types";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import { createTheme } from "@mui/material/styles";
import DashboardIcon from "@mui/icons-material/Dashboard";
import AirlineSeatReclineNormalIcon from "@mui/icons-material/AirlineSeatReclineNormal";
import DirectionsBusIcon from "@mui/icons-material/DirectionsBus";
import SettingsIcon from "@mui/icons-material/Settings";
import FaceIcon from "@mui/icons-material/Face";
import { AppProvider } from "@toolpad/core/AppProvider";
import { DashboardLayout } from "@toolpad/core/DashboardLayout";
import { useDemoRouter } from "@toolpad/core/internal";
import SettingsPage from "./settings/SettingsPage";
import StudentManagementPage from "./studentManagement/StudentManagementPage";
import DriverManagementPage from "./driverManagement/DriverManagementPage";
import VehicleManagementPage from "./vehicleManagement/VehicleManagementPage";

const NAVIGATION = [
  
  {
    segment: "students",
    title: "Student Management",
    icon: <FaceIcon />,
  },
  {
    segment: "drivers",
    title: "Driver Management",
    icon: <AirlineSeatReclineNormalIcon />,
  },
  {
    segment: "vehicles",
    title: "Vehicle Management",
    icon: <DirectionsBusIcon />,
  },
  {
    segment: "settings",
    title: "Settings",
    icon: <SettingsIcon />,
  },
];

const demoTheme = createTheme({
  palette: {
    primary: { main: "#3A5AF3" },
    
  },
  cssVariables: {
    colorSchemeSelector: "data-toolpad-color-scheme",
  },
  colorSchemes: { light: true, dark: true },
  breakpoints: {
    values: {
      xs: 0,
      sm: 600,
      md: 600,
      lg: 1200,
      xl: 1536,
    },
  },
});

function DemoPageContent({ pathname }) {
  return (
    <Box
      sx={{
        py: 4,
        display: "flex",
        flexDirection: "column",
        marginLeft:'1rem'
      }}
    >
      <Typography>{pathname}</Typography>
    </Box>
  );
}

DemoPageContent.propTypes = {
  pathname: PropTypes.string.isRequired,
};

function DashboardLayoutNoMiniSidebar(props) {
  const router = useDemoRouter("/students");

  return (
    <AppProvider
      branding={{
        logo: <img src="/logo.png" alt="hope on logo" />,
        title: "HopeOn",
      }}
      navigation={NAVIGATION}
      router={router}
      theme={demoTheme}
    >
      <DashboardLayout disableCollapsibleSidebar>
        {router.pathname === "/settings" && <SettingsPage />}
        {router.pathname === "/students" && <StudentManagementPage />}
        {router.pathname === "/drivers" && <DriverManagementPage />}
        {router.pathname === "/vehicles" && <VehicleManagementPage />}
      </DashboardLayout>
    </AppProvider>
  );
}

DashboardLayoutNoMiniSidebar.propTypes = {
  window: PropTypes.func,
};

export default DashboardLayoutNoMiniSidebar;
