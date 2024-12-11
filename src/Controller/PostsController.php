<?php

namespace App\Controller;

use App\Entity\Post;
use App\Repository\PostRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/posts')]
class PostsController extends AbstractController
{
    #[Route('/', name: 'posts')]
    public function posts(PostRepository $postRepository): Response
    {
        return $this->render('posts/index.html.twig', [
            'posts' => $postRepository->findAll(),
        ]);
    }
}
