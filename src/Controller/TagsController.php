<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class TagsController extends AbstractController
{
    #[Route('/tags', name: 'app_tags')]
    public function index(): Response
    {
        return $this->render('tags/index.html.twig', [
            'controller_name' => 'TagsController',
        ]);
    }
}
