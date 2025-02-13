import React from "react";
import { CircularProgress, Box, Typography } from "@mui/material";

const LoadingEffect = () => {

  return(
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        minHeight: "50vh",
      }}
    >
      <CircularProgress />
      <Typography variant="h6" sx={{ mt: 2 }}>
        Loading, please wait...
      </Typography>
    </Box>
  );
};

export default LoadingEffect;
