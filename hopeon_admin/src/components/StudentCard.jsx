import * as React from "react";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import CardMedia from "@mui/material/CardMedia";
import Typography from "@mui/material/Typography";

export default function StudentCard({student}) {
  return (
    <Card sx={{ display: "flex", cursor: "pointer" }} >
      <CardMedia
        component="img"
        sx={{ width: 150, height: 170 }}
        image="student.jpg"
        alt="Live from space album cover"
      />
      <Box sx={{ display: "flex", flexDirection: "column" }}>
        <CardContent sx={{ flex: "1 0 auto" }}>
          <Typography component="div" variant="h6">
            {student.fullName}
          </Typography>
          <Typography
            variant="subtitle1"
            component="div"
            sx={{ color: "text.secondary" }}
          >
            {student.grade+" - "+student.studentClass}
          </Typography>
        </CardContent>
        <Box sx={{ display: "flex", alignItems: "center", pl: 2, pb: 2 }}>
          <Typography component="div" variant="h8">
            Reg No: {student.regNo}
          </Typography>
        </Box>
      </Box>
    </Card>
  );
}
