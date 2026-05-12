package com.petwellness.model;

public class Clinic {

    private int clinicId;
    private String clinicName;
    private String address;
    private String city;
    private String zipCode;
    private double latitude;
    private double longitude;
    private String services;
    private String speciesSupported;
    private boolean appointmentAvailable;
    private double rating;
    private double distance;

    // Getters and Setters

    public int getClinicId() {
        return clinicId;
    }

    public void setClinicId(int clinicId) {
        this.clinicId = clinicId;
    }

    public String getClinicName() {
        return clinicName;
    }

    public void setClinicName(String clinicName) {
        this.clinicName = clinicName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getServices() {
        return services;
    }

    public void setServices(String services) {
        this.services = services;
    }

    public String getSpeciesSupported() {
        return speciesSupported;
    }

    public void setSpeciesSupported(String speciesSupported) {
        this.speciesSupported = speciesSupported;
    }

    public boolean isAppointmentAvailable() {
        return appointmentAvailable;
    }

    public void setAppointmentAvailable(boolean appointmentAvailable) {
        this.appointmentAvailable = appointmentAvailable;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }
}