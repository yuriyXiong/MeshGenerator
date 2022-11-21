# MeshGenerator：A grid generation package in MATLAB
MeshGenerator is a matlab software package used to generate various two-dimensional meshes such as triangles, squares, polygons, etc. It can be used for finite element method and virtual element method. The code is based on IFEM and mVEM， and I have mainly done some original work in generating linear and closed interface grids.

If you need to communicate with me, you can contact me via email: 202121511185@smail.xtu.edu.cn

## installation
Add the path to MeshGenerator into the path library of MATLAB:
  1.Graphical interface. Click File -> Set Path -> Add with Subfolders and chose the directory where the package iFEM is stored.
  2.Command window. Go to the directory of MeshGenerator and run setpath
  
## NormalMesh
  You can generate a normal mesh in a square, or get polygonal mesh and unstructured mesh by original mesh：
  ### 1.dualMesh.m
  It can be used to generate a polygonal mesh by original triangular mesh data.
  ### 2.nonConvexMesh.m
  It can be used to generator a Non convex polygon mesh, which can be used in virtual element method.
  ### 3.NonStructural_Mesh.m
  This script file stores how to convert a normal grid into a structured grid by random methods.
  ### 4.squaremesh.m
  It can be used to generate a uniform triangular mesh.
  ### 5.squarequadmesh.m
  It can be used to generate a uniform squared mesh.

## PolyMesher
  You can read the annotation of PolyMesher.m and PolyMesher_interfaceline.m to generator Voronoi polygonal mesh and mirrored Voronoi polygonal mesh,respectively.
  
## DistMesh
  You can read the annotation of distmesh2d.m to generator Mesh of domains with very many shapes,even the grid with holes.
  
## InterfacePolymesher
  This is my main original work. I created programs that can generate linear interfaces and programs with closed interfaces. See the specific annotation of example in the code for the main usage.

