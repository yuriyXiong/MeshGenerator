# MeshGenerator:A Mesh generation package in MATLAB
MeshGenerator is a matlab software package used to generate various meshes in 2D such as triangles, squared, Voronoi polygons, even non-convex polygons, etc. It can be used for finite element method and virtual element method. The code is based on iFEM and mVEM (Thanks to Professor Chen Long of UCL and Terenceyuyue of SJTU) , and I have mainly done some original work in generating linear and closed interface meshes.

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
  This script file stores how to convert a normal grid into a non-structured mesh by random methods.
  ### 4.squaremesh.m
  It can be used to generate a uniform triangular mesh.
  ### 5.squarequadmesh.m
  It can be used to generate a uniform squared mesh.

## PolyMesher
  This part is relatively independent. You can read the documents in the folder to understand its usage. If you simply use it, you can read the annotation of PolyMesher.m and PolyMesher_interfaceline.m to generator Voronoi polygonal mesh and mirrored Voronoi polygonal mesh,respectively.
  
## DistMesh
  You can read the annotation of distmesh2d.m to generator Mesh of domains with very many shapes,even the grid with holes.
  
## InterfacePolymesher
  This is my main original work. I created programs that can generate linear and closed interfaces. See the specific annotation of example in the interfaceline.m and interfacecolosed.m for the main usage.
