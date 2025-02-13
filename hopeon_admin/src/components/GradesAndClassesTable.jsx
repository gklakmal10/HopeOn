import * as React from "react";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";
import { Box, IconButton } from "@mui/material";
import DeleteIcon from "@mui/icons-material/Delete";
import EditGradeModal from "./EditGradeModal";
import DeleteModal from "./common/DeleteModal";
import { deleteGradeClass, findAllGradeClass } from "../service/gradeClassService";
import LoadingEffect from "./common/Loading";

export default function GradesAndClassesTable({ setFetchDataFunction }) {
  const [rows, setRows] = React.useState([]);
  const [loading, setLoading] = React.useState(false);

  const fetchAllGradeClasses = async () => {
    setLoading(true);
    await findAllGradeClass()
      .then(({ data }) => {
        setRows(data.object);
        setLoading(false);
      })
      .catch((err) => {
        setLoading(false);
        console.log(err);
      });
  };

  React.useEffect(() => {
    fetchAllGradeClasses();
    setFetchDataFunction(() => fetchAllGradeClasses);
  }, [setFetchDataFunction]);

  const deleteButton = (func) => {
    return (
      <IconButton onClick={() => func()}>
        <DeleteIcon />
      </IconButton>
    );
  };

  const deleteGrade=async(id)=>{
    await deleteGradeClass(id).then(({data})=>{
      fetchAllGradeClasses()
    }).catch((err)=>{
      console.log(err)
    })
  }

  return (
    <>
      {loading ? (
        <LoadingEffect />
      ) : (
        <TableContainer component={Paper}>
          <Table sx={{ minWidth: 650 }} aria-label="simple table">
            <TableHead>
              <TableRow>
                <TableCell>Grade</TableCell>
                <TableCell align="left">Classes</TableCell>
                <TableCell align="center">Action</TableCell>
              </TableRow>
            </TableHead>
            {rows.length !== 0 ? (
              <TableBody>
                {rows.map((row) => (
                  <TableRow key={row.grade}>
                    <TableCell width={200}>{row.grade}</TableCell>
                    <TableCell width={700} align="left">
                      {row.classes}
                    </TableCell>
                    <TableCell align="center">
                      <div>
                        <EditGradeModal gradeData={row} fetchAll={fetchAllGradeClasses} />
                        <DeleteModal
                          text={"Are you sure, you want to delete this?"}
                          button={deleteButton}
                          func={() => {
                            deleteGrade(row.id);
                          }}
                        />
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            ) : (
              <>
                <Box
                  sx={{
                    display: "flex",
                    justifyContent: "center",
                    margin: "2rem",
                  }}
                >
                  No grades and classes to display, please add grades and
                  classes.
                </Box>
              </>
            )}
          </Table>
        </TableContainer>
      )}
    </>
  );
}
